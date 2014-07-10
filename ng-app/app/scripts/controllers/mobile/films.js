'use strict';

/**
 * @ngdoc function
 * @name animefolio.controller:FilmsCtrl
 * @description
 * # FilmsCtrl
 * Controller of the animefolio
 */

angular.module("animefolio").controller("FilmsCtrl", function ($scope, $location, http) {
	$scope.api = {
		films: []
	};
	$scope.status = {};
	var page_num;

 	$scope.initialize = function () {
 		$(".menu").css("display", "none");
		$("body").css("overflow", "auto");
		$(".layer").css("display", "none");
 		$scope.status.loading = true;
 		page_num = 1;
 		var letter = $location.search().letter;
 		var keyword = $location.search().keyword;
 		var type = $location.search().type;

 		if(keyword){
 			http.searchFilms($scope.api, page_num, $scope.status, pagenation, keyword);
 		}
 		else if(type){
 			http.getPopularOrRecentFilms($scope.api, page_num, $scope.status, pagenation, type)
 		}
 		else{
 			http.getFilms($scope.api, page_num, $scope.status, pagenation, letter);
 		}
 	}

 	function pagenation(){
		var scrollHeight = $(document).height();
		var scrollPosition = $(window).height() + $(window).scrollTop();
		if((scrollHeight - scrollPosition) / scrollHeight <= 0.1){
			$scope.status.loading = true;
			$(window).unbind("scroll");
			page_num += 1;
			var letter = $location.search().letter;
			var keyword = $location.search().keyword;
			var type = $location.search().type;
            if(keyword){
	 			http.searchFilms($scope.api, page_num, $scope.status, pagenation, keyword);
	 		}
	 		else if(type){
	 			http.getPopularOrRecentFilms($scope.api, page_num, $scope.status, pagenation, type)
	 		}
	 		else{
	 			http.getFilms($scope.api, page_num, $scope.status, pagenation, letter);
	 		}
		}
	}
});

