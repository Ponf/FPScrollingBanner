
Pod::Spec.new do |s|
  s.name             = "FPScrollingBanner"
  s.version          = "1.0.0"
  s.summary          = "This Objective-C control implements Scrolling Inset Banner appearance for tvOS apps"

  s.description      = <<-DESC
                        FPScrollingBanner allows to easily recreate Scrolling Inset Banner appearance like on new AppleTV dashboard. It's based on UICollectionView and tweaks Focusing System to create infinitive scrolling experience.
                        DESC

  s.homepage         = "https://github.com/Ponf/FPScrollingBanner"
  s.license          = 'MIT'
  s.author           = { "Filipp" => "me@ponfius.com" }
  s.source           = { :git => "https://github.com/Ponf/FPScrollingBanner.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/ponfius'

  s.platform     = :tvos, '9.0'
  s.tvos.deployment_target = '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.frameworks = 'UIKit'

end
