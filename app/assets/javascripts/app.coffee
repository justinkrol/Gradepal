gradepal = angular.module 'gradepal',[
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
  'angular-flash.service',
  'angular-flash.flash-alert-directive'
]

gradepal.config [ '$routeProvider', 'flashProvider',
  ($routeProvider, flashProvider)->

    flashProvider.errorClassnames.push('alert-danger')
    flashProvider.warnClassnames.push("alert-warning")
    flashProvider.infoClassnames.push("alert-info")
    flashProvider.successClassnames.push("alert-success")

    $routeProvider
      .when '/',
        templateUrl: 'index.html'
        controller: 'CoursesController'
      .when '/courses/new',
        templateUrl: 'form.html'
        controller: 'CourseController'
      .when '/courses/:courseId',
        templateUrl: 'show.html'
        controller: 'CourseController'
      .when '/courses/:courseId/edit',
        templateUrl: 'form.html'
        controller: 'CourseController'
]

controllers = angular.module('controllers',[])
