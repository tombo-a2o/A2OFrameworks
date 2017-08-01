cc_flags = '-s FULL_ES2=1'
html_flags = '-s FULL_ES2=1 -s TOTAL_MEMORY=134217728'

debug_runtime_parameters = {
  emscripten: {
    http_logging: true
  },
  shell: {
    auto_launch: 'asmjs'
  }
}

config = {
  version: 1,
  xcodeproj_path: 'iOSInAppPurchases.xcodeproj',
  xcodeproj_target: 'iOSInAppPurchases',
  a2o_targets: {
    debug: {
      xcodeproj_build_config: 'Debug',
      flags: {
        cc: "-O0 #{cc_flags}",
        html: "-O0 -s OBJC_DEBUG=1 #{html_flags} --emrun"
      },
      runtime_parameters: debug_runtime_parameters
    }
  }
}

# puts config

config
