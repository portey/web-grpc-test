package main

import (
	"context"
	"log"
	"net"

	"google.golang.org/grpc"
	"test/backend/api"
)

type server struct {
	api.UnimplementedEchoServerServer
}

func (s *server) Echo(_ context.Context, r *api.EchoRequest) (*api.EchoResponse, error) {
	log.Println("new request")

	return &api.EchoResponse{Message: r.GetMessage()}, nil
}

func main() {
	lis, err := net.Listen("tcp", ":80")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	s := grpc.NewServer()

	api.RegisterEchoServerServer(s, &server{})

	log.Printf("server listening at %v", lis.Addr())
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}
