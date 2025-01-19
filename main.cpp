#include <iostream>
#include <string>
#include <curl/curl.h>
#include <string.h>
#include <chrono>
#include <thread>

struct DuckDNSParams
{
  std::string domainName;
  std::string APIToken;
};

static size_t WriteCallback(void *contents, size_t size, size_t nmemb, void *userp)
{
  ((std::string *)userp)->append((char *)contents, size * nmemb);
  return size * nmemb;
}

std::string getRequest(std::string&& url)
{
  CURL *handle;
  CURLcode res;
  std::string readBuffer;

  handle = curl_easy_init();
  if (handle == NULL)
  {
    std::cerr << "Failed to initialize cULR" << std::endl;
    return "";
  }

  curl_easy_setopt(handle, CURLOPT_URL, url.c_str());
  curl_easy_setopt(handle, CURLOPT_WRITEFUNCTION, WriteCallback);
  curl_easy_setopt(handle, CURLOPT_WRITEDATA, &readBuffer);
  res = curl_easy_perform(handle);
  curl_easy_cleanup(handle);

  if (res != 0)
  {
    std::cerr << "cURL error: " << curl_easy_strerror(res) << std::endl;
  }
  return readBuffer;
}

const std::string duckDNSRequest(const DuckDNSParams& params, std::string& newIp)
{
  return getRequest("https://www.duckdns.org/update?domains=" + params.domainName + "&token=" + params.APIToken + "&ip=" + newIp);
}

const std::string ipRequest()
{
  return getRequest("https://api.ipify.org/");
}

int main()
{
  std::cout << "Process started. Checking dynamic dns changes every 60 seconds" << std::endl;
  if (std::getenv("API_KEY") == nullptr || std::getenv("DOMAIN_NAME") == nullptr) {
    std::cerr << "Must include API_KEY and DOMAIN_NAME" << std::endl;
    return 1;
  }

  const DuckDNSParams getParams = {std::getenv("DOMAIN_NAME"), std::getenv("API_KEY")};

  // Initial duckdns request
  std::string oldResult = ipRequest();
  if (oldResult.empty())
  {
    std::cout << "Initial request to api.ipify failed." << std::endl;
  }
  duckDNSRequest(getParams, oldResult);

  // Loop to keep check and updating the dynamic dns
  while (1)
  {
    std::string newResult = ipRequest();
    if (newResult.compare(oldResult)) // IP has changed. Make duckdns request
    {
      duckDNSRequest(getParams, newResult);
      oldResult = newResult;
    }
    std::this_thread::sleep_for(std::chrono::seconds(60)); // Sleep for 60 seconds
  }

  return 0;
}