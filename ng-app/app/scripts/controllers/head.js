'use strict';

/**
 * @ngdoc function
 * @name animefolio.controller:HeadCtrl
 * @description
 * # HeadCtrl
 * Controller of the animefolio
 */

angular.module("animefolio").controller("HeadCtrl", function ($scope, $location) {
  $scope.api = {};
  $scope.$on("film", function (event, result) {
    $scope.api.film = result;
  })
});

