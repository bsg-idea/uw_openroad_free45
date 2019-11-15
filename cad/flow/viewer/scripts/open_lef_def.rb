options = RBA::LoadLayoutOptions::new
lefdef_options = RBA::LEFDEFReaderConfiguration::new
lefdef_options.lef_files = [ENV["REL_LEF_FILE"]]
options.lefdef_config = lefdef_options
mw = RBA::Application::instance.main_window
mw.load_layout(ENV["DEF_FILE"], options, 1)
