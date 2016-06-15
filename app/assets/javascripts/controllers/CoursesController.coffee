controllers = angular.module('controllers')
controllers.controller("CoursesController", [ '$scope', '$routeParams', '$location', '$resource', 'flash'
  ($scope, $routeParams, $location, $resource, flash)->
    $scope.search = (keywords)->  $location.path('/').search('keywords',keywords)
    Course = $resource('/courses/:courseId', {courseId: '@id', format: 'json' },
      {
        'delete': {method: 'DELETE'}
        'create': {method: 'POST'}
      }
    )

    # Variables
    $scope.showNewCourseInput = false

    updateList = ()->
      if $routeParams.keywords
        Course.query(keywords: $routeParams.keywords, (results)-> $scope.courses = results)
      else
        Course.query((results)-> $scope.courses = results)

    $scope.view = (courseId)-> $location.path("/courses/#{courseId}")
    $scope.newCourse = -> $location.path("courses/new")
    $scope.edit = (courseId)-> $location.path("/courses/#{courseId}/edit")
    $scope.delete = (courseId)->
      $scope.course = Course.get({courseId: courseId},
        ()-> $scope.course.$delete().then(
          ( value )-> updateList(),
          ( error )-> alert('error')
        )
      )
    $scope.showNewCourse = ()->
      $scope.newCourse = {}
      $scope.showNewCourseInput = true

    $scope.submitCourse = ()->
      console.log('Submitting course')
      onError = (_httpResponse)->
        flash.error = "Something went wrong"
        alert("ERROR")
      Course.create($scope.newCourse,
        ( (createdCourse)->
          flash.sucess = "Course created"
          console.log('Created course with id' + createdCourse.id)
          updateList()),
        onError
      )
      $scope.showNewCourseInput = false
      # need to do this after or the create can't get the info from the scope since the form is hidden

    # Init
    updateList()
])
