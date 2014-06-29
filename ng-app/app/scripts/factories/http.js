angular.module("animefolio").factory("http", ["$http", "$rootScope", function ($http, $rootScope){
	var HOST = "http://127.0.0.1:3000";
	function http (url, method, data, success_fn, error_fn) {
		$http({
			url: url,
			method: method,
			data: data,
			withCredentials: true,
			header: {
                'Content-Type': 'application/x-www-form-urlencoded'
            }
		})
		.success(success_fn)
		.error(error_fn);
	}

	return {
		getFilms: function () {
			http(HOST + "/films", "GET", {},
				function (data, status, headers, config) {
					console.log(data);
				},
				function (data, status, headers, config) {
					console.log("error");
				}
			)
		}
	}
}])