# xcodeEditor

To Create a Group named "Dir"
xcode.rb "path/to/Project.xcodeproj" Dir


To Create a Group named "Dir" and "file.swift" inside "Dir"
xcode.rb "path/to/Project.xcodeproj" Dir file.swift

To Create a Group named "Dir" inside "DirTop" and "file.swift" inside "Dir/DirTop"
xcode.rb "path/to/Project.xcodeproj" DirTop/Dir file.swift
