Pod::Spec.new do |s|
s.name             = 'SATextfield'
s.version          = '0.0.3'
s.summary          = 'SATextfield use to quick design layout of different type of UITextField.'

s.description      = <<-DESC
This framework is made with intension to have extended functionality to use UITextField. You can have Dropdown, Underline, Floaty textfield, Infoview, PasswordView with textfield. This code provides all in one tool to manage textfield.

There are some of types that use to quick layout design:

.underLine
.dashedLine
.border
.borderWithCornerRadius
.password
.floaty
.dropdown
.infoView

DESC

s.homepage         = 'https://github.com/sapankajbhalala/SATextField'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'Solution Analyst' => 'pankaj.bhalala.sa@gmail.com' }
s.swift_version = '4.2'
s.source           = { :git => "https://github.com/sapankajbhalala/SATextfield.git", :tag => "#{s.version}" }

s.ios.deployment_target = '10.0'
s.source_files = 'SATextfield/SATextfieldEx/Utils/CustomComps/Sources/*.swift'
# s.resource_bundle = {'SAVideoPlayer' => ['SAVideoPlayer/Assest/**/*.{png}']}
end