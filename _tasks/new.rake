def create(title)
  filename = "_posts/#{Time.now.strftime('%Y-%m-%d')}-#{title.to_url}.markdown"
  if File.exist?(filename)
    abort("rake aborted!") if ask("#{filename} already exists. Do you want to overwrite?", ['y', 'n']) == 'n'
  end
  open(filename, 'w') do |post|
    post.puts "---"
    post.puts "layout: post"
    post.puts "title: \"#{title.gsub(/&/,'&amp;')}\""
    post.puts "date: #{Time.now.strftime('%Y-%m-%d %H:%M:%S %z')}"
    post.puts "external-url: "
    post.puts "mirror: "
    post.puts "---"
  end
  filename
end

task :create, :title do |t, args|
  if args.title
    title = args.title
  else
    title = get_stdin("Enter a title for your post: ")
  end

  create(title)
end

desc "Add a stuff"
task :new, :title do |t, args|
  if args.title
    title = args.title
  else
    title = get_stdin("Enter a title for your post: ")
  end

  create(title)
  puts filename
  sh "vim", filename
  sh "git", "add", filename
  sh "git", "commit", "-m \"Add '#{title.gsub(/"/, '\"')}'\""
end
