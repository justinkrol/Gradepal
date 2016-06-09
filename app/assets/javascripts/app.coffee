gradepal = angular.module 'gradepal',[
  'templates',
  'ngRoute',
  'ngResource',
  'controllers',
]

gradepal.config [ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when '/',
        templateUrl: 'index.html'
        controller: 'CoursesController'
]

controllers = angular.module('controllers',[])
