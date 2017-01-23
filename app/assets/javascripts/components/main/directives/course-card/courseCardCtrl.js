(function () {
  angular.module('gradepal.main.controllers').controller('CourseCardCtrl', CourseCardCtrl);

  CourseCardCtrl.$inject = ['$scope', '$http', 'flashService'];

  function CourseCardCtrl($scope, $http, flashService) {
    var ctrl = this;
    ctrl.editing = false;

    ctrl.init = function () {
      ctrl.editing = $scope.gpEditing;
      ctrl.selected = false;
      ctrl.getComponents();
    }

    ctrl.removeComponent = function (componentId) {
      $scope.gpCourse.components = $scope.gpCourse.components.filter(function(component) { return component.id != componentId; });
    }

    ctrl.addComponent = function (component) {
      $scope.gpCourse.components.push(component);
    }

    ctrl.getComponents = function () {
      if($scope.gpCourse && $scope.gpCourse.id) {
        $http.get('/components', {params: {course_id: $scope.gpCourse.id, format:'json'}}).then(function(results){
          $scope.gpCourse.components = results.data .sort(function (a,b) {
            return a.id - b.id;
          });
        });
      }
    }

    ctrl.showNewComponent = function () {
      ctrl.addingComponent = true; // view will show the appropriate box
    }

    ctrl.toggleSelect = function () {
      if (ctrl.isSelected = !ctrl.isSelected){
        ctrl.getComponents();
      }
    }

    ctrl.edit = function () {
      ctrl.editing = true;
      console.log('Editing course with id: ' + $scope.gpCourse.id);
    }

    ctrl.delete = function () {
      if(window.confirm("Are you sure you want to delete '" + $scope.gpCourse.code + " - " + $scope.gpCourse.name + "'?")){
        console.log('Deleting course with id: ' + $scope.gpCourse.id);
        $http.delete('/courses/'+ $scope.gpCourse.id).then(function(){
          $scope.gpParentCtrl.removeCourse($scope.gpCourse.id);
        });
      }
    }

    ctrl.save = function () {
      console.log('Saving course with code: ' + $scope.gpCourse.code + ', name: ' + $scope.gpCourse.name);
      // Existing course
      if($scope.gpCourse && $scope.gpCourse.id) {
        $http.put('/courses/'+ $scope.gpCourse.id, $scope.gpCourse, {params: {format:'json'}}).then(function(){
          console.log('Updated course with id ' + $scope.gpCourse.id);
          ctrl.editing = false;
        }, function(results){
          flashService.showErrors(results.data.errors);
        });
      }
      // New course
      else {
        $http.post('/courses', $scope.gpCourse, {params: {format:'json'}}).then(function(results){
          $scope.gpCourse = results.data;
          console.log('Created course with id: ' + $scope.gpCourse.id);
          $scope.gpParentCtrl.addCourse(results.data);
          $scope.gpParentCtrl.addingCourse = false;
          ctrl.editing = false;
        }, function(results) {
          flashService.showErrors(results.data.errors);
        });
      }
    }

    ctrl.cancel = function () {
      console.log('Cancelling edit');
      if($scope.gpCourse && $scope.gpCourse.id) { // existing course
        console.log('Cancel changes to course');
        Course.get({courseId: $scope.gpCourse.id}, function (result) {
          console.log(result);
          $scope.gpCourse = result;
        });
      }
      ctrl.editing = false;
      $scope.gpParentCtrl.addingCourse = false;
    }

    ctrl.average = function () {
      if($scope.gpCourse.components && $scope.gpCourse.components.length > 0) {
        var componentAverages = [];
        $scope.gpCourse.components.forEach(function(component) { 
          avg = componentAverage(component.grades)
          if(avg){
            componentAverages.push(avg)
          }
        });

        if(componentAverages.length > 0){
          return (componentAverages.reduce(function(a,b) {return a + b;}, 0) / componentAverages.length).toFixed(1) + '%';
        }
        else{
          return 'No grades'
        }
      }
      else{
        return 'No components';
      }
    }

    var componentAverage = function (grades) {
      if (grades.length > 0) {
        return (grades.reduce(function(a,b) {return a + (b.score / b.max);}, 0) * 100
          / grades.length);
      }
      else {
        return null;
      }
    }

    ctrl.init();
  }

})();
