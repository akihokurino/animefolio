worker_processes 2

project_root = File.expand_path("../", __FILE__)
listen "#{project_root}/tmp/unicorn.sock"
pid "#{project_root}/tmp/pids/unicorn.pid"

stderr_path "#{project_root}/log/unicorn_err.log"
stdout_path "#{project_root}/log/unicorn.log"
preload_app true