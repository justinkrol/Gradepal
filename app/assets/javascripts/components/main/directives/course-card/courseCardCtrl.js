(function () {
  angular.module('gradepal.main.controllers').controller('CourseCardCtrl', CourseCardCtrl);

  CourseCardCtrl.$inject = ['$scope', '$http', 'flash'];

  function CourseCardCtrl($scope, $http, flash) {
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
      console.log('Deleting course with id: ' + $scope.gpCourse.id);
      $http.delete('/courses/'+ $scope.gpCourse.id).then(function(){
        $scope.$destroy();
      });
      $scope.gpParentCtrl.removeCourse($scope.gpCourse.id);
    }

    ctrl.save = function () {
      console.log('Saving course with code: ' + $scope.gpCourse.code + ', name: ' + $scope.gpCourse.name);
      var onError = function (_httpResponse) {
        flash.error = 'Something went wrong';
      }
      if (!$scope.gpCourse.code) { // bad input
        flash.error = 'Please enter a code for the course';
        return;
      }
      if (!$scope.gpCourse.name) { // bad input
        flash.error = 'Please enter a name for the course';
        return;
      }
      ctrl.editing = false; // successful, so close dialog

      if($scope.gpCourse && $scope.gpCourse.id) { // This is an existing course if it already has an id; editing, not creating
        $http.put('/courses/'+ $scope.gpCourse.id, $scope.gpCourse, {params: {format:'json'}}).then(function(){
          console.log('Updated course with id ' + $scope.gpCourse.id);
        });
      }
      else { // This is a new course if it does not have an id
        $http.post('/courses', $scope.gpCourse, {params: {format:'json'}}).then(function(results){
          $scope.gpCourse = results.data;
          console.log('Created course with id: ' + $scope.gpCourse.id);
          $scope.gpParentCtrl.addCourse(results.data);
          $scope.gpParentCtrl.addingCourse = false;
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

    ctrl.init();
  }

})();
