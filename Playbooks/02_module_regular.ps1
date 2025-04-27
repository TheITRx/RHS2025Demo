$name = "Jocel Sabellano"
$gender = "Male"
$email = "Jocel.s@theItrx.com"
$status = "Active"


# Define the URL and headers
$url = "https://gorest.co.in/public/v2/users"
$headers = @{
    "Accept"        = "application/json"
    "Content-Type"  = "application/json"
    "Authorization" = "Bearer 32646123a8dce5a1c59f4db3beb5bba928b0b92676d57ff7bf1c449d6a693cb6"
}

# Define the JSON payload
$body = @{
    "name"   = $name
    "gender" = $gender
    "email"  = $email
    "status" = $status
} | ConvertTo-Json

# Make the POST request
$response = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $body
$result = @{}
if($response){
    $result['user'] = $response 
    $result['result_code'] = 0
    $result['result_message'] = "User Created Successfully"
    $result['status'] = "success"
}
# Output the response
Write-Output [PSCustomObject]@{
    Response = $Response
    Result = $result
}
