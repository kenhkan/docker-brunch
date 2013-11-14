child_process = require 'child_process'

cwd = process.cwd()

module.exports = class DockerRunner
  brunchPlugin: yes
  type: 'javascript'
  extension: 'js'
  pattern: /src\/.+\.(js|coffee|litcoffee)/

  constructor: (@config) ->
    {
      input_dir
      output_dir
    } = @config.plugins?.docker or {}

    # Deal with options
    @prefix = input_dir or ''
    @inputDir = if input_dir? then " -i #{cwd}/#{input_dir}" else ''
    @outputDir = if output_dir? then " -o #{cwd}/#{output_dir}" else ''

  compile: (params, callback) ->
    # Run Docker only changed files, which are relative to project's root
    @runDocker [params.path]

    callback null, params

  runDocker: (files = []) ->
    # Make sure files are relative to `cwd`
    files = for file in files
      # Remove prefix as it's in the file
      file.replace (new RegExp "^#{@prefix}/"), ''

    command = """
      #{__dirname}/../node_modules/.bin/docker#{@inputDir}#{@outputDir} #{files.join ' '}
    """

    # Run Docker executable with files
    child_process.exec command, (error, stdout, stderr) ->
      console.log "exec error: #{error}" if error?
