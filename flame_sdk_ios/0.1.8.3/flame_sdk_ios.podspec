Pod::Spec.new do |s|
  s.name             = 'flame_sdk_ios'
  s.version          = '0.1.8.3'
  s.summary          = 'Flame iOS Ad SDK'
  s.description      = 'Flame iOS advertising aggregation SDK'
  s.homepage         = 'https://github.com/javaice007/flame_sdk_ios'
  s.author           = { 'flame' => 'flame@toowe.com' }

  s.source           = {
    :http => "https://github.com/javaice007/flame_sdk_ios/archive/refs/tags/#{s.version}.zip",
  }

  # 商业sdk
  s.license = {
    :type => 'Commercial',
    :text => 'Copyright Flame'
  }

  # 3. 平台要求
  s.ios.deployment_target = '12.0'
  s.swift_version = '5.0'

  # Binary SDK
  s.vendored_frameworks = '**/flame_sdk_ios.xcframework'

  # ========= AD Core =========
  s.dependency 'OpenSSL-Universal', '1.1.180'
  
  s.dependency 'AnyThinkiOS','6.5.71'
  #Anythink Kuying Adx SDK(necessary)
  s.dependency 'AnyThinkMediationAdxSmartdigimktCNAdapter','6.5.72.2.1'
  s.dependency 'AnyThinkMediationGromoreAdapter','7.6.0.4.2.0'
  s.dependency 'AnyThinkMediationBaiduAdapter','10.050.2.1'
  #Baidu--4.80 SDK,podfile文件顶部增加 source 'https://github.com/CocoaPods/Specs.git'
  s.dependency 'AnyThinkMediationMSAdapter','2.7.18.1.2.0'
  s.dependency 'AnyThinkMediationZYAdapter','2.6.4.29.2.0'
  s.dependency 'AnyThinkMediationFunlinkAdapter','2.9.0.1.2.2.0'
  s.dependency 'AnyThinkMediationBeiZiAdapter','5.5.0.3.2.0'
  s.dependency 'AnyThinkMediationKuaiShouAdapter','5.4.10.1.2.0'
  s.dependency 'AnyThinkMediationSigmobAdapter','4.20.12.2.0'
  s.dependency 'AnyThinkMediationTTAdapter_Mix','7.6.0.4.2.0'
  s.dependency 'AnyThinkMediationGDTAdapter','4.15.90.2.0'

  # AdGain 广告 SDK + Taku/TopOn 适配器
  s.dependency 'AdGainSDK','4.2.7.1'
  s.dependency 'AdGainSDKTakuAdapter','4.2.7.1'

  # 飞梭
  s.dependency 'FSUnionAdSDK', '1.0.8.0'

  
  # 注意：不要写 s.source_files，因为你不需要向用户分发源代码
  s.pod_target_xcconfig = {
    'OTHER_LDFLAGS' => '-ObjC',
    'DEFINES_MODULE' => 'YES'
  }

  # 剥离所有依赖 framework 内嵌的 bitcode（Apple 已废弃 bitcode，App Store 不接受含 bitcode 的二进制）
  s.script_phase = {
    :name => 'Strip Bitcode from Dependencies',
    :script => <<~SCRIPT,
      echo "🧹 [flame_sdk_ios] Stripping bitcode from embedded frameworks..."
      find "${BUILT_PRODUCTS_DIR}/${FRAMEWORKS_FOLDER_PATH}" -type f -perm +111 -name "*.framework" | while read fw_dir; do
        binary="$fw_dir/$(basename "$fw_dir" .framework)"
        if [ -f "$binary" ] && xcrun bitcode_strip "$binary" -r -o "$binary" 2>/dev/null; then
          echo "  stripped: $(basename "$fw_dir")"
        fi
      done
      echo "✅ [flame_sdk_ios] Bitcode stripping done"
    SCRIPT
    :execution_position => :after_embed_frameworks
  }
end
