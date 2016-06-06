gradepal = angular.module 'gradepal',[
  'templates',
  'ngRoute',
  'controllers',
]

gradepal.config [ '$routeProvider',
  ($routeProvider)->
    $routeProvider
      .when '/',
        templateUrl: 'index.html'
        controller: 'RecipesController'
]

items = [
  {
    id: 1
    name: 'Hockey Puck'
  },
  {
    id: 2
    name: 'Hockey Stick'
  },
  {
    id: 3
    name: 'Baseball Bat'
  },
  {
    id: 4
    name: 'Basketball Hoop'
  },
]

controllers = angular.module('controllers',[])
controllers.controller("RecipesController", [ '$scope', '$routeParams', '$location',
  ($scope, $routeParams, $location)->
    $scope.search = (keywords)->  $location.path('/').search('keywords',keywords)

    if $routeParams.keywords
      keywords = $routeParams.keywords.toLowerCase()
      $scope.items = items.filter (item)-> item.name.toLowerCase().indexOf(keywords) != -1
    else
      $scope.items = []
])
