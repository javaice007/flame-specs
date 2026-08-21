# ============================================================
# Flame Content SDK — flame_content_sdk_ios 0.1.0 podspec
# ------------------------------------------------------------
# 私有 Spec Repo（flame-specs）版本索引。二进制分发（vendored xcframework）：
# 与源码仓库（开发）严格分离；本 spec 的 source 指向二进制发布仓库。
# 依赖（Ads-CN / PangrowthX / TTSDKFramework）由本 spec 传递引入，
# Flame 二进制内的三方符号（DJX 等）经 -undefined dynamic_lookup 在宿主进程
# 运行时解析（A2/A3 契约：Flame 二进制不内嵌三方 SDK）。
#
# 客户接入：pod 'flame_content_sdk_ios'（默认 Content 子 spec，真机运行）
# 模拟器开发：pod 'flame_content_sdk_ios/CoreAds'（无内容栈，模拟器可用）
# ============================================================
Pod::Spec.new do |s|
  s.name             = 'flame_content_sdk_ios'
  s.version          = '0.1.0'
  s.summary          = 'Flame Content SDK for iOS.'
  s.description      = 'Flame Content SDK: CSJ Content capability plus Direct GroMore rewarded ads behind a single Flame-facing API.'
  s.homepage         = 'https://github.com/javaice007/flame_content_sdk_ios'
  s.license          = { :type => 'Proprietary', :text => 'Internal project; distribution terms are defined by the owner.' }
  s.author           = { 'Flame' => 'sdk@invalid.local' }

  # 二进制发布仓库（dist repo，对齐 flame_sdk_ios 模型）：tag = 版本号，
  # tag archive 根路径承载 vendored xcframework。
  s.source = { :git => 'https://github.com/javaice007/flame_content_sdk_ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '13.0'
  s.requires_arc          = true

  s.module_name        = 'flame_content_sdk_ios'
  s.frameworks         = ['Foundation', 'UIKit']

  # vendored 二进制（dist repo 根路径，随 tag 发布）
  s.vendored_frameworks = 'flame_content_sdk_ios.xcframework'

  s.pod_target_xcconfig = {
    'OTHER_LDFLAGS' => ['$(inherited)', '-undefined', 'dynamic_lookup']
  }

  # ---- A3.1：客户默认分发 = B2（默认含 Content，真机运行）----
  s.default_subspecs = ['Content']

  s.subspec 'CoreAds' do |ads|
    # A2 冻结的 Direct GroMore 依赖
    ads.dependency 'Ads-CN/CSJMediation-Only', '7.7.0.6'
  end

  # ---- A3：CSJ Content（短剧）能力（device-only）----
  s.subspec 'Content' do |csj|
    csj.dependency 'flame_content_sdk_ios/CoreAds'
    csj.dependency 'PangrowthX/shortplay', '2.9.0.6'
    csj.dependency 'TTSDKFramework/Player-SR', '1.42.3.4-premium'
  end
end
