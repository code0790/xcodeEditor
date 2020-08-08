#!/usr/bin/ruby
require 'xcodeproj'
require 'fileutils'


def isGroupContains (parentGroup, dr)
	parentGroup.groups.each do |i|
		if i.path == dr
			return true, i
		end
	end
	return false, ""
end


def createGroup (parentGroup, child, path_so_far)
	value = isGroupContains(parentGroup, child)
	if value[0]
		#puts "exists #{path_so_far}"
		return value[1]
	else
		#puts "creating #{path_so_far}"
		Dir.mkdir path_so_far
		child = parentGroup.new_group(child,path = path_so_far)
		return child
	end
end


def createFile (path)
	last = path.split("/")[-1].split(".")[0]
	if File.file?(path)
		return false
	else
		#for other utils
		#my_dir = Dir["/Users/navpreetsingh/Documents/Snippets/dump/#{last}"]
		#my_dir.each do |filename|
  		#	FileUtils.cp(filename, path)
		#end
		out_file = File.new(path, "w")
		out_file.puts("write your stuff here")
		out_file.close
		return true
	end
end


def addFilesToTarget (project,group,aPath,files)
	for afile in files
		createFile(aPath+"/"+afile+".swift")
		project.targets.first.add_file_references([group.new_file(afile+".swift")])
	end
end

path_to_xcodeproj = ARGV[0]
main_dir_path = path_to_xcodeproj.gsub('.xcodeproj', '/')
project_ref = Xcodeproj::Project.open(path_to_xcodeproj)
main_group_name = path_to_xcodeproj.split("/")[-1].gsub('.xcodeproj', '')
main_group_ref = project_ref.main_group[main_group_name]

files_info = []
directory_info = []


if ARGV.length == 1
	puts "Please specify arguments: Dir/SubDir OR Dir/SubDir fileOne/fileTwo"
	exit
elsif ARGV.length == 2
	directory_info = ARGV[1].split("/") 
elsif ARGV.length == 3
	directory_info = ARGV[1].split("/") 
	files_info = ARGV[2].split("/") 
end



my_path = ""
now_parent = main_group_ref
for child in directory_info
	my_path += child+"/"
	now_parent = createGroup(now_parent, child, main_dir_path+my_path.delete_suffix('/'))
end


for afile in files_info
	if createFile(main_dir_path+my_path+afile+".swift")
		project_ref.targets.first.add_file_references([now_parent.new_file(afile+".swift")])
	end
end


project_ref.save
