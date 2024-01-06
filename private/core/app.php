<?php

class App
{

    // properties
    protected $controller = "home";
    protected $method = "index";
    protected $params = array();

    // constructor
    function __construct()
    {
        $url = ($this->getUrl());

        // checking existence of a class
        if (file_exists("../private/controllers/" . $url[0] . ".php")) {
            $this->controller = $url[0];
            unset($url[0]);
        }

        require "../private/controllers/" . $this->controller . ".php";
        $this->controller = new $this->controller();


        // Checking existence of method in the above class
        if (isset($url[1])) {
            if (method_exists($this->controller, $url[1])) {
                $this->method = $url[1];
                unset($url[1]);
            }
        }

        // Setting Parameters

        $url = array_values($url);
        $this->params = $url;
        // echo "<pre>";
        // print_r($url);

        call_user_func_array([$this->controller, $this->method], $this->params);
    }

    // methods
    public function getUrl()
    {
        // echo "<pre>";
        $url = isset($_GET['url']) ? $_GET['url'] : "home";
        return explode("/", filter_var(trim($url, "/")), FILTER_SANITIZE_URL);
    }
}
