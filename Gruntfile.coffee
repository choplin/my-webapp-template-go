module.exports = (grunt)->
  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    bower:
      install:
        options:
          targetDir: './public/vendor'
          install: true
          verbose: false
          cleanTargetDir: true
          cleanBowerDir: false

    watch:
      coffee:
        files: ['src/coffee/**/*.coffee']
        tasks: 'coffee'
      stylus:
        files: ['src/stylus/**/*.stylus']
        tasks: 'stylus'
      options:
        livereload: true

    coffee:
      compile:
        options:
          join: true
        files:
          'public/js/app.js': 'src/coffee/*.coffee'

    stylus:
      compile:
        files:
          'public/css/app.css': 'src/stylus/*.stylus'

    clean:
      build: ['public/js', 'public/css']
      install: ['public/vendor']
      bower: ['bower_components']
      npm: ['node_modules']

  grunt.loadNpmTasks 'grunt-bower-task'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-shell'

  grunt.registerTask 'install', ['bower:install']
  grunt.registerTask 'build', ['coffee', 'stylus']
  grunt.registerTask 'init', ['install', 'build']
  grunt.registerTask 'default', ['watch']
