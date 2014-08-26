Pod::Spec.new do |s|
  s.name         = "JPPopSequenceAnimation"
  s.version      = "1.0"
  s.summary      = "Sequence Animation using POP"
  s.homepage     = "http://www.juanpecatalan.com"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Juanpe Catalán" => "juanpecm@gmail.com" }
  s.platform     = :ios, '7.0'
  s.source       = { 
  		:git => "https://github.com/Juanpe/JPPopSequenceAnimation.git", 
  		:tag => "1.0" 
  		}
  s.source_files = 'JPPopSequenceAnimation/JPPopSequenceAnimationClasses/JPPopSequenceAnimation.{h,m}','JPPopSequenceAnimation/JPPopSequenceAnimationClasses/JPPopSequenceCoordinator.{h,m}'
  s.requires_arc = true
  s.dependency 'pop'
  s.platform = :ios, '7.0'
end

