(function () {
  angular.module('gradepal.main.controllers').controller('ComponentCardCtrl', ComponentCardCtrl);

  ComponentCardCtrl.$inject = ['$scope', '$resource', 'flash'];

  function ComponentCardCtrl($scope, $resource, flash) {
    var Component = $resource('courses/:courseId/components/:componentId', {courseId: '@courseId', componentId: '@id', format: 'json' },
      {
        'delete': {method: 'DELETE'},
        'create': {method: 'POST'},
        'save': {method: 'PUT'}
      });
    var Grade = $resource('courses/:courseId/components/:componentId/grades/:gradeId', {courseId: '@courseId', componentId: '@componentId', gradeId: '@id', format: 'json' },
      {
        'delete': {method: 'DELETE'},
        'create': {method: 'POST'},
        'save': {method: 'PUT'}
      });

    var ctrl = this;
    ctrl.editing = false;

    ctrl.init = function () {
      ctrl.component = $scope.gpComponent ? $scope.gpComponent : {};
      // ctrl.component.id = $scope.gpComponentId;
      ctrl.editing = $scope.gpEditing;
      ctrl.addingGrade = false;
      ctrl.selected = false;
      ctrl.getGrades();
    }

    ctrl.showNewGrade = function () {
      ctrl.addingGrade = true; // view will show the appropriate box
    }

    ctrl.toggleSelect = function () {
      ctrl.isSelected = !ctrl.isSelected
    }

    ctrl.getGrades = function () {
      if(ctrl.component.id) {
        Grade.query({courseId: $scope.gpCourseCtrl.course.id, componentId: ctrl.component.id}, function (results) {
          ctrl.component.grades = results.sort(function (a,b) {
            return a.id - b.id;
          });
        });
      }
    }

    ctrl.edit = function () {
      ctrl.editing = true;
      ctrl.temp = {name: ctrl.component.name, weight: ctrl.component.weight};
      console.log('Editing component with id: ' + ctrl.component.id);
    }

    ctrl.delete = function () {
      console.log('Deleting component with id: ' + ctrl.component.id);
      ctrl.component.$delete({courseId: $scope.gpCourseCtrl.course.id, componentId: ctrl.component.id}, function(){
        $scope.$destroy();}
      );

    }

    ctrl.save = function () {
      console.log('Saving component with name: ' + ctrl.component.name + ', weight: ' + ctrl.component.weight );
      var onError = function (_httpResponse) {
        flash.error = 'Something went wrong';
      }
      if (!ctrl.component.name) { // bad input
        flash.error = 'Please enter a name for the component';
        return;
      }
      if (!ctrl.component.weight) { // bad input
        flash.error = 'Please enter a weight for the component';
        return;
      }
      ctrl.editing = false; // successful, so close dialog

      if(ctrl.component.id) { // This is an existing component if it already has an id; editing, not creating
        ctrl.component.$save({courseId: $scope.gpCourseCtrl.course.id, componentId: ctrl.component.id},
          (function() {
            console.log('Updated component with id ' + ctrl.component.id);
          }),
          onError
        );
      }
      else { // This is a new component if it does not have an id
        ctrl.component.courseId = $scope.gpCourseCtrl.course.id;
        Component.create(ctrl.component, (
          function (createdComponent) {
            // flash.success = "Component created successfully"
            ctrl.component = createdComponent;
            console.log('Created component with id: ' + ctrl.component.id);
            $scope.gpCourseCtrl.getComponents();
            $scope.gpCourseCtrl.addingComponent = false;
          }),
            onError
        );
      }
    }

    ctrl.cancel = function () {
      console.log('Cancelling edit');
      if(ctrl.component.id && ctrl.temp) { // existing component
        console.log('a');
        ctrl.component.name = ctrl.temp.name;
        ctrl.component.weight = ctrl.temp.weight;
      }
      ctrl.editing = false;
      $scope.gpCourseCtrl.addingComponent = false;
    }

    ctrl.init();
  }

})();
