'use strict';

/**
 * @ngdoc function
 * @name ngAppApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the ngAppApp
 */

angular.module("animefolio").controller("MainCtrl", function ($scope, http) {
	$scope.api = {};
	var page_num;

 	$scope.initialize = function () {
 		page_num = 1;
 		http.getFilms($scope.api, page_num);
 	}
});
