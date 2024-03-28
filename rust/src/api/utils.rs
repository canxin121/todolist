use uuid::Uuid;

#[flutter_rust_bridge::frb]
pub fn gen_uuid_v4() -> String {
    return Uuid::new_v4().to_string();
}
