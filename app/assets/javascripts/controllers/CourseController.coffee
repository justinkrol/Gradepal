controllers = angular.module('controllers')
controllers.controller('CourseController', ['$scope', '$routeParams', '$resource', '$location', 'flash'
  ($scope, $routeParams, $resource, $location, flash)->
    Course = $resource('/courses/:courseId', { courseId: '@id', format: 'json' },
      {
        'save':   {method:'PUT'}
        'create': {method:'POST'}
      })
    if $routeParams.courseId
      Course.get({courseId: $routeParams.courseId},
        ( (course)-> $scope.course = course),
        ( (httpResponse)->
          $scope.course = null
          flash.error = "There is no course with ID #{$routeParams.courseId}")
      )
    else
      $scope.course = {}

    $scope.back   = -> $location.path("/")
    $scope.edit   = -> $location.path("/courses/#{$scope.course.id}/edit")
    $scope.cancel = ->
      if $scope.course.id
        $location.path("/courses/#{$scope.course.id}")
      else
        $location.path("/")
    $scope.save   = ->
      onError = (_httpResponse)-> flash.error = "Something went wrong"
      if $scope.course.id
        $scope.course.$save(
          ( ()-> $location.path("/courses/#{$scope.course.id}") ),
          onError)
      else
        Course.create($scope.course,
          ( (newCourse)-> $location.path("/courses/#{newCourse.id}") ),
          onError
        )
    $scope.delete = ->
      $scope.course.$delete()
      $scope.back()
])
