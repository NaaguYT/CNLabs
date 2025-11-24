#include <bits/stdc++.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
using namespace std;

#define PORT 8080

int main() {
    int server_fd = socket(AF_INET, SOCK_STREAM, 0);

    sockaddr_in addr{};
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = INADDR_ANY;
    addr.sin_port = htons(PORT);

    bind(server_fd, (sockaddr*)&addr, sizeof(addr));
    listen(server_fd, 3);

    cout << "Server running...\n";

    socklen_t addrlen = sizeof(addr);
    int client_socket = accept(server_fd, (sockaddr*)&addr, &addrlen);

    char filename[256] = {0};
    read(client_socket, filename, sizeof(filename));

    ifstream file(filename);
    string data, line;

    if (file.is_open()) {
        while (getline(file, line)) data += line + "\n";
    } else {
        data = "FILE NOT FOUND\n";
    }

    send(client_socket, data.c_str(), data.size(), 0);

    close(client_socket);
    close(server_fd);
}
