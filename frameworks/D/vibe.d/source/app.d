import vibe.d;


shared static this()
{
	auto settings = new HTTPServerSettings;
        auto router = new URLRouter;
        router.registerRestInterface(new DaStuff);
        router.get("/plaintext", &plaintext);
	settings.port = 8081;
	settings.bindAddresses = ["::1", "127.0.0.1"];
	listenHTTP(settings, router);

	logInfo("Please open http://127.0.0.1:8081/ in your browser.");
}

class Message {
    string message;
}

interface IDaStuff {
    @property Message json();
}

class DaStuff : IDaStuff {
    @property Message json() {
        auto message = new Message;
        message.message = "Hello, World!";
        return message;
    }
}

void plaintext(HTTPServerRequest request, HTTPServerResponse response) {
    response.writeBody("Hello, World!");
}
