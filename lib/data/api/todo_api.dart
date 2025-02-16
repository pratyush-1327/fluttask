import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/todo_model.dart';

part 'todo_api.g.dart';

@RestApi(baseUrl: "https://todocrud.chiggydoes.tech")
abstract class TodoApi {
  factory TodoApi(Dio dio, {String baseUrl}) = _TodoApi;

  @GET("/todos/")
  Future<List<Todo>> getTodos(@Header("X-API-Key") String apiKey);

  @POST("/todos/")
  Future<Todo> createTodo(
      @Header("X-API-Key") String apiKey, @Body() Map<String, dynamic> todo);

  @PUT("/todos/{id}")
  Future<Todo> updateTodo(@Header("X-API-Key") String apiKey,
      @Path("id") int id, @Body() Map<String, dynamic> todo);

  @DELETE("/todos/{id}")
  Future<void> deleteTodo(
      @Header("X-API-Key") String apiKey, @Path("id") int id);
}
