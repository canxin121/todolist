#![allow(non_snake_case)]
use log::info;
use serde::{Deserialize, Serialize};
use tokio::{
    fs::{self, create_dir_all},
    io::{AsyncReadExt, AsyncWriteExt},
};

use super::config::CONFIG;
use std::path::PathBuf;

const TODOLIST_FILENAME: &'static str = "todolist.json";

#[flutter_rust_bridge::frb]
#[derive(Debug, Serialize, Deserialize)]
pub struct TodoData {
    #[frb(non_final)]
    pub id: String,
    pub description: String,
    pub startTime: String,
    pub endTime: String,
}

#[flutter_rust_bridge::frb]
pub async fn write_todolist(todolist: Vec<TodoData>) -> Result<(), anyhow::Error> {
    let config = CONFIG.read().await;
    let mut file_path = PathBuf::from(&config.cache_root);
    file_path.push(TODOLIST_FILENAME);
    let json = serde_json::to_string(&todolist)?;
    info!(
        "write todolist of len: {} to {:?}",
        todolist.len(),
        file_path
    );
    if !file_path.exists() {
        if let Some(parent_path) = file_path.parent() {
            if !parent_path.exists() {
                create_dir_all(parent_path).await?;
            }
        }
        let mut file = fs::File::create(&file_path).await?;
        file.write_all(json.as_bytes()).await?;
    } else {
        let mut file = fs::OpenOptions::new()
            .write(true)
            .truncate(true)
            .open(&file_path)
            .await?;
        file.write_all(json.as_bytes()).await?;
    }

    Ok(())
}

#[flutter_rust_bridge::frb]
pub async fn get_todolist() -> Result<Vec<TodoData>, anyhow::Error> {
    // if not exist, return empty vec;
    let config = CONFIG.read().await;
    let mut file_path = PathBuf::from(&config.cache_root);
    file_path.push(TODOLIST_FILENAME);
    if !file_path.exists() {
        info!("{:?} not exists, return empty vec.", file_path);
        return Ok(Vec::with_capacity(0));
    } else {
        let mut json = String::new();
        let mut file = fs::File::open(file_path).await?;
        file.read_to_string(&mut json).await?;
        let todolist = serde_json::from_str::<Vec<TodoData>>(&json)?;
        info!("get_todolist of len: {}", todolist.len());
        Ok(todolist)
    }
}
