controllers = angular.module('controllers')
controllers.controller('CourseController', ['$scope', '$routeParams', '$resource',
  ($scope, $routeParams, $resource)->
    Course = $resource('/courses/:courseId', { courseId: '@id', format: 'json' })

    Course.get({courseId: $routeParams.courseId},
      ( (course)-> $scope.course = course),
      ( (httpResponse)-> $scope.course = null)
    )
])
