package structs

type ContactRequest struct {
	Id string `json:"id"`
	FirstName string `json:"first_name"`
	LastName string `json:"last_name"`
	Status string `json:"status"`
	Created string `json:"created"`
	Updated string `json:"updated"`
}
