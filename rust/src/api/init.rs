use flutter_logger::flutter_logger_init;
flutter_logger_init!();

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    flutter_rust_bridge::setup_default_user_utils();
}
