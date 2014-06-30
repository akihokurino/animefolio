'use strict';

/**
 * @ngdoc function
 * @name ngAppApp.controller:MainCtrl
 * @description
 * # MainCtrl
 * Controller of the ngAppApp
 */

angular.module("animefolio").controller("MainCtrl", function ($scope, $location, http) {
	$scope.api = {
		films: []
	};
	$scope.status = {};
	var page_num;

 	$scope.initialize = function () {
 		$scope.status.loading = true;
 		page_num = 1;
 		var letter = $location.search().letter;
 		http.getFilms($scope.api, page_num, $scope.status, pagenation, letter);
 	}

 	function pagenation(){
		var scrollHeight = $(document).height();
		var scrollPosition = $(window).height() + $(window).scrollTop();
		if((scrollHeight - scrollPosition) / scrollHeight <= 0.1){
			$scope.status.loading = true;
			$(window).unbind("scroll");
			page_num += 1;
			var letter = $location.search().letter;
            http.getFilms($scope.api, page_num, $scope.status, pagenation, letter);
		}
	}
});

