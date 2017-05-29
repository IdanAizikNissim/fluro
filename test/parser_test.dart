/*
 * fluro
 * A Posse Production
 * http://goposse.com
 * Copyright (c) 2017 Posse Productions LLC. All rights reserved.
 * See LICENSE for distribution and usage details.
 */
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fluro/fluro.dart';

void main() {

  testWidgets("Router correctly parses named parameters", (WidgetTester tester) async {
    String path = "/users/1234";
    String route = "/users/:id";
    Router router = new Router();
    router.define(route, handler: null);
    AppRouteMatch match = router.match(path);
    expect(match?.parameters, equals(<String, String>{
      "id" : "1234",
    }));
  });

  testWidgets("Router correctly parses named parameters with query", (WidgetTester tester) async {
    String path = "/users/1234?name=luke";
    String route = "/users/:id";
    Router router = new Router();
    router.define(route, handler: null);
    AppRouteMatch match = router.match(path);
    expect(match?.parameters, equals(<String, String>{
      "id" : "1234",
      "name" : "luke",
    }));
  });

  testWidgets("Router correctly parses query parameters", (WidgetTester tester) async {
    String path = "/users/create?name=luke&phrase=hello%20world&number=7";
    String route = "/users/create";
    Router router = new Router();
    router.define(route, handler: null);
    AppRouteMatch match = router.match(path);
    expect(match?.parameters, equals(<String, String>{
      "name" : "luke",
      "phrase" : "hello world",
      "number" : "7",
    }));
  });

  testWidgets("Router uses correct route priority", (WidgetTester tester) async {
    double testValue = 0.0;
    Router router = new Router();
    router.define("/test/static", handler: new Handler(type: HandlerType.function,
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          testValue = 10.0;
        }));
    router.define("/test/:common", handler: new Handler(type: HandlerType.function,
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          testValue = 20.0;
        }));
    router.navigateTo(null, "/test/static");
    expect(testValue, equals(10.0));
  });

  testWidgets("Router uses correct named parameter route priority", (WidgetTester tester) async {
    double testValue = 0.0;
    Router router = new Router();
    router.define("/test/static", handler: new Handler(type: HandlerType.function,
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          testValue = 10.0;
        }));
    router.define("/test/:common", handler: new Handler(type: HandlerType.function,
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          testValue = 20.0;
        }));
    router.navigateTo(null, "/test/hello");
    expect(testValue, equals(20.0));
  });

  testWidgets("Router correctly uses named parameter route priority (nested)", (WidgetTester tester) async {
    double testValue = 0.0;
    Router router = new Router();
    router.define("/test/static", handler: new Handler(type: HandlerType.function,
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          testValue = 10.0;
        }));
    router.define("/test/:common", handler: new Handler(type: HandlerType.function,
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          testValue = 20.0;
        }));
    router.define("/test/:common/nested", handler: new Handler(type: HandlerType.function,
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          testValue = 30.0;
        }));
    router.navigateTo(null, "/test/hello/nested");
    expect(testValue, equals(30.0));
  });

  testWidgets("Router correctly uses the NotFound handler", (WidgetTester tester) async {
    String foundTest = "found";
    Router router = new Router();
    router.notFoundHandler = new Handler(type: HandlerType.function,
        handlerFunc: (BuildContext context, Map<String, dynamic> params) {
          foundTest = "not found";
        });
    router.define("/test1", handler: null);
    router.define("/test2", handler: null);
    router.navigateTo(null, "/test3");
    expect(foundTest, equals("not found"));
  });

}