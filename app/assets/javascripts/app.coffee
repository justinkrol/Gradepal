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
      .when '/courses/:courseId',
        templateUrl: 'show.html'
        controller: 'CourseController'
]

controllers = angular.module('controllers',[])
