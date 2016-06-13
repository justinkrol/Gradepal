controllers = angular.module('controllers')
controllers.controller("CoursesController", [ '$scope', '$routeParams', '$location', '$resource',
  ($scope, $routeParams, $location, $resource)->
    $scope.search = (keywords)->  $location.path('/').search('keywords',keywords)
    Course = $resource('/courses/:courseId', {courseId: '@id', format: 'json' },
      {
        'delete': {method: 'DELETE'}
      }
    )

    if $routeParams.keywords
      Course.query(keywords: $routeParams.keywords, (results)-> $scope.courses = results)
    else
      # $scope.courses = []
      Course.query((results)-> $scope.courses = results)

    $scope.view = (courseId)-> $location.path("/courses/#{courseId}")
    $scope.newCourse = -> $location.path("courses/new")
    $scope.edit = (courseId)-> $location.path("/courses/#{courseId}/edit")
    $scope.delete = (courseId)->
      $scope.course = Course.get({courseId: courseId},
        ()-> $scope.course.$delete().then(
          ( value )-> $scope.courses.splice($scope.courses.indexOf(courseId), 1), # remove 1 item at index
          ( error )-> alert('error')
        )
      )
])
