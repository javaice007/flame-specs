# ============================================================
# Flame Content SDK — flame_content_sdk_ios 0.1.0 podspec
# ------------------------------------------------------------
# 私有 Spec Repo（flame-specs）版本索引。源码 + transitive 三方
# 依赖分发（A3.1 单 Pod 契约）：默认 Content（真机），CoreAds（模拟器）。
# s.source = github 源码仓库 javaice007/flame_content_sdk_ios，tag = 0.1.0。
# 客户接入：pod 'flame_content_sdk_ios'
# ============================================================
Pod::Spec.new do |s|
  s.name         = 'flame_content_sdk_ios'
  s.version      = '0.1.0'
  s.summary      = 'Flame Content SDK for iOS.'
  s.description  = 'Flame Content SDK: CSJ Content capability plus Direct GroMore rewarded ads behind a single Flame-facing API.'
  s.homepage     = 'https://example.invalid/flame_content_sdk_ios'
  s.license      = { :type => 'Proprietary', :text => 'Internal project; distribution terms are defined by the owner.' }
  s.author       = { 'Flame' => 'sdk@invalid.local' }
  s.source       = { :git => 'https://github.com/javaice007/flame_content_sdk_ios.git', :tag => s.version.to_s }
  s.platform     = :ios, '13.0'
  s.requires_arc = true
  s.source_files = 'flame_content_sdk_ios/**/*.{h,m}'
  s.public_header_files = [
    'flame_content_sdk_ios/flame_content_sdk_ios.h',
    'flame_content_sdk_ios/Public/FlameContentSdk.h',
    'flame_content_sdk_ios/Public/FlameCallback.h',
    'flame_content_sdk_ios/Public/FlameRewardAd.h',
    'flame_content_sdk_ios/Public/FlameContentEntry.h',
    'flame_content_sdk_ios/Public/FlameContentAuxiliary.h'
  ]
  s.frameworks   = 'Foundation', 'UIKit'
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES',
    # Direct GroMore 以 transitive pod 依赖透传给宿主；Flame 二进制不内嵌三方广告 SDK。
    'FRAMEWORK_SEARCH_PATHS' => ['$(inherited)', '$(PODS_ROOT)/Ads-CN/SDK/BUAdSDK.xcframework/ios-arm64', '$(PODS_ROOT)/Ads-CN/SDK/BUAdSDK.xcframework/ios-arm64_x86_64-simulator'],
    'OTHER_LDFLAGS' => ['$(inherited)', '-undefined', 'dynamic_lookup']
  }

  # ---- A3.1：客户默认分发 = B2（默认含 Content，真机运行）----
  # 冻结记录：docs/context/接入内容SDK/10_A3_1_CUSTOMER_DISTRIBUTION.md
  #   CUSTOMER_DEFAULT_DISTRIBUTION = B2_CUSTOMER_SPEC_WITH_CONTENT
  #   CUSTOMER_POD_USAGE = pod 'flame_content_sdk_ios'（客户不写 /Content、不写三方 pod）
  #   CUSTOMER_CONTENT_RUNTIME_PLATFORM = DEVICE_ARM64（内容栈无模拟器切片，A1 实证）
  # 内部开发/模拟器验证使用 'flame_content_sdk_ios/CoreAds'（无内容栈，模拟器可用）。
  s.default_subspecs = ['Content']

  s.subspec 'CoreAds' do |ads|
    # A2 冻结的 Direct GroMore 依赖（docs/context/接入GroMore广告/10_A2_GROMORE_DEPENDENCY_DECISION.md）
    ads.dependency 'Ads-CN/CSJMediation-Only', '7.7.0.6'
  end

  # ---- A3：CSJ Content（短剧）能力（device-only）----
  # 工程基线 = lite + 显式点播内核（full 2.9.0.6 所需 TTVideoEngine 组件在公开源引擎 1.0.0.0 中
  # 不存在，A1/A3 nm 实证；lite 与 full 短剧功能一致，官方语义差异仅为内核内置与否）。
  # 正式版本以平台生成命令复核替换：CONTENT_FORMAL_VERSION_SOURCE = PENDING_PLATFORM_GENERATED_COMMAND。
  s.subspec 'Content' do |csj|
    csj.dependency 'flame_content_sdk_ios/CoreAds'
    csj.dependency 'PangrowthX/shortplay', '2.9.0.6'
    csj.dependency 'TTSDKFramework/Player-SR', '1.42.3.4-premium'
    # PangrowthX/shortplay → PangrowthDJX 2.9.0.6 + PGXToolbox 2.9.0.6 + TTSDKFramework/Player-SR
    csj.pod_target_xcconfig = {
      'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) FLAME_CONTENT_DEVICE=1',
      'FRAMEWORK_SEARCH_PATHS' => ['$(inherited)', '$(PODS_ROOT)/PangrowthDJX/PangrowthDJX', '$(PODS_ROOT)/PGXToolbox/PGXToolbox']
    }
  end
end
