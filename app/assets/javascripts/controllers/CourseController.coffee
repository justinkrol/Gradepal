controllers = angular.module('controllers')
controllers.controller('CourseController', ['$scope', '$routeParams', '$resource', 'flash'
  ($scope, $routeParams, $resource, flash)->
    Course = $resource('/courses/:courseId', { courseId: '@id', format: 'json' })

    Course.get({courseId: $routeParams.courseId},
      ( (course)-> $scope.course = course),
      ( (httpResponse)->
        $scope.course = null
        flash.error = "There is no course with ID #{$routeParams.courseId}")
    )
])
