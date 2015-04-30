import vibe.d;
import std.process;
import std.random;
import ddb.postgres;


shared static this()
{
    auto settings = new HTTPServerSettings;
    auto router = new URLRouter;
    router.registerRestInterface(new DaStuff);
    router.get("/plaintext", &plaintext);
    settings.port = 8081;
    settings.bindAddresses = ["::1", "127.0.0.1"];
    listenHTTP(settings, router);
}

class Message {
    string message;
}

class DBResult {
    int id;
    int randomNumber;
}

interface IDaStuff {
    @property Message json();
    @property DBResult db();
}

class DaStuff : IDaStuff {
    @property Message json() {
        auto message = new Message;
        message.message = "Hello, World!";
        return message;
    }

    @property DBResult db() {
        auto result = new DBResult;
        result.id = uniform!"[]"(1, 10000);

        auto conn = new PGConnection([
            "host": environment.get("DBHOST", ""),
            "database": "hello_world",
            "user": "benchmarkdbuser",
            "password": "benchmarkdbpass",
        ]);
        scope(exit) conn.close();

        auto cmd = new PGCommand(conn, 
            "SELECT randomnumber FROM World where id=$1;");
        cmd.parameters.add(1, PGType.INT4).value = result.id;
        auto rows = cmd.executeQuery();
        scope(exit) rows.close();

        auto row = rows.front;
        result.randomNumber = row["randomnumber"].get!int;

        return result;
    }
}

void plaintext(HTTPServerRequest request, HTTPServerResponse response) {
    response.writeBody("Hello, World!");
}

