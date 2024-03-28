use std::sync::Arc;

use lazy_static::lazy_static;
use tokio::sync::RwLock;
lazy_static! {
    pub static ref CONFIG: Arc<RwLock<Config>> = Arc::new(RwLock::new(Config::default()));
}

#[derive(Debug)]
pub struct Config {
    pub cache_root: String,
}

impl Default for Config {
    fn default() -> Self {
        Config {
            cache_root: "./".to_string(),
        }
    }
}

pub async fn init_config(config: Config) {
    let mut global_config = CONFIG.write().await;
    (*global_config) = config;
}
