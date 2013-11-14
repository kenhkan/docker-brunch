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
    @inputDir = if input_dir? then " -i #{cwd}/#{input_dir}" else ''
    @outputDir = if output_dir? then " -o #{cwd}/#{output_dir}" else ''

  lint: (data, path, callback) ->
    # Run through the entire directory at once again because we need Docker to
    # generate the directory tree
    command = """
      #{__dirname}/../node_modules/.bin/docker#{@inputDir}#{@outputDir} #{@inputDir}
    """

    # Run Docker
    child_process.exec command, (error, stdout, stderr) ->
      console.log "exec error: #{error}" if error?

    callback null
