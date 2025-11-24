#include <bits/stdc++.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#include <unistd.h>
using namespace std;

#define PORT 8080

int main() {
    int sock = socket(AF_INET, SOCK_STREAM, 0);

    sockaddr_in serv{};
    serv.sin_family = AF_INET;
    serv.sin_port = htons(PORT);
    inet_pton(AF_INET, "127.0.0.1", &serv.sin_addr);

    connect(sock, (sockaddr*)&serv, sizeof(serv));

    string filename;
    cout << "Enter file name: ";
    cin >> filename;

    send(sock, filename.c_str(), filename.size(), 0);

    char buffer[4096] = {0};
    read(sock, buffer, sizeof(buffer));

    cout << "\n--- FILE CONTENT ---\n" << buffer;

    close(sock);
}
