gradepal = angular.module 'gradepal',[
  # angular
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
  'angular-flash.service',
  'angular-flash.flash-alert-directive',

  # components
  'gradepal.main'
]

gradepal.config [ '$routeProvider', 'flashProvider',
  ($routeProvider, flashProvider)->

    # flashProvider.setTimeout(5000)
    # flashProvider.setShowClose(true)
    flashProvider.errorClassnames.push('alert-danger')
    flashProvider.warnClassnames.push("alert-warning")
    flashProvider.infoClassnames.push("alert-info")
    flashProvider.successClassnames.push("alert-success")

    $routeProvider
      .when '/',
        templateUrl: 'index.html'
        controller: 'CoursesController'

]

controllers = angular.module('controllers',[])
