package com.sourcegraph.demo.bigbadmonolith;

import jakarta.ws.rs.*;
import jakarta.ws.rs.core.MediaType;
import jakarta.ws.rs.core.Response;
import com.sourcegraph.demo.bigbadmonolith.entity.User;
import com.sourcegraph.demo.bigbadmonolith.service.DatabaseService;
import java.util.List;

@Path("/users")
@Produces(MediaType.APPLICATION_JSON)
@Consumes(MediaType.APPLICATION_JSON)
public class UserResource {
    
    private final DatabaseService dbService = new DatabaseService();
    
    @GET
    public List<User> getAllUsers() {
        return dbService.findAllUsers();
    }
    
    @GET
    @Path("/{id}")
    public Response getUserById(@PathParam("id") Long id) {
        User user = dbService.findUserById(id);
        if (user == null) {
            return Response.status(Response.Status.NOT_FOUND).build();
        }
        return Response.ok(user).build();
    }
    
    @POST
    public Response createUser(User user) {
        if (user.getEmail() == null || user.getName() == null) {
            return Response.status(Response.Status.BAD_REQUEST)
                    .entity("Email and name are required").build();
        }
        
        // Check if user already exists
        if (dbService.findUserByEmail(user.getEmail()) != null) {
            return Response.status(Response.Status.CONFLICT)
                    .entity("User with this email already exists").build();
        }
        
        User savedUser = dbService.saveUser(user);
        return Response.status(Response.Status.CREATED).entity(savedUser).build();
    }
}
