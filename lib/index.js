// Generated by CoffeeScript 1.3.3
(function() {
  var DockerRunner, child_process, cwd;

  child_process = require('child_process');

  cwd = process.cwd();

  module.exports = DockerRunner = (function() {

    DockerRunner.prototype.brunchPlugin = true;

    DockerRunner.prototype.type = 'javascript';

    DockerRunner.prototype.extension = 'js';

    DockerRunner.prototype.pattern = /src\/.+\.(js|coffee|litcoffee)/;

    function DockerRunner(config) {
      var input_dir, output_dir, _ref, _ref1;
      this.config = config;
      _ref1 = ((_ref = this.config.plugins) != null ? _ref.docker : void 0) || {}, input_dir = _ref1.input_dir, output_dir = _ref1.output_dir;
      this.inputDir = input_dir != null ? " -i " + cwd + "/" + input_dir : '';
      this.outputDir = output_dir != null ? " -o " + cwd + "/" + output_dir : '';
    }

    DockerRunner.prototype.lint = function(data, path, callback) {
      var command;
      command = "" + __dirname + "/../node_modules/.bin/docker" + this.inputDir + this.outputDir + " " + this.inputDir;
      child_process.exec(command, function(error, stdout, stderr) {
        if (error != null) {
          return console.log("exec error: " + error);
        }
      });
      return callback(null);
    };

    return DockerRunner;

  })();

}).call(this);
