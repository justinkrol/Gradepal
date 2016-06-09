controllers = angular.module('controllers')
controllers.controller("CoursesController", [ '$scope', '$routeParams', '$location', '$resource',
  ($scope, $routeParams, $location, $resource)->
    $scope.search = (keywords)->  $location.path('/').search('keywords',keywords)
    Course = $resource('/courses/:courseId', {courseId: '@id', format: 'json' })

    if $routeParams.keywords
      Course.query(keywords: $routeParams.keywords, (results)-> $scope.courses = results)
    else
      $scope.courses = []
])
