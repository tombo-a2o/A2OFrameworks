cc_flags = '-DTARGET_OS_IOS=1'
html_flags = '-s TOTAL_MEMORY=268435456 -lNocilla'

debug_runtime_parameters = {
  emscripten: {
    http_proxy_url_prefixes: [
    ],
    http_proxy_server: 'http://localhost:4567/proxy',
    http_logging: true
  },
  shell: {
    auto_launch: "asmjs",
    auto_mute: true
  }
}

config = {
  version: 1,
  xcworkspace_path: 'StoreKit.xcworkspace',
  xcodeproj_name: 'StoreKit',
  xcodeproj_target: 'StoreKitTests',
  a2o_targets: {
    debug: {
      xcodeproj_build_config: 'Debug',
      flags: {
        cc: "-O1 #{cc_flags}",
        html: "-O0 -s OBJC_DEBUG=1 -s TRACE_CXX_EXCEPTIONS=1 #{html_flags} --emrun  -La2o/build/debug/Pods-Nocilla/pre_products"
      },
      runtime_parameters: debug_runtime_parameters
    }
  }
}

# puts config

config
