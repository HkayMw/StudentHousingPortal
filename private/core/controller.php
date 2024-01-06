<?php

class Controller
{
    // properties

    // methods
    public function view($viewName)
    {
        if (file_exists("../private/views/" . $viewName . ".view.php")) {
            require "../private/views/" . $viewName . ".view.php";
        } else {
            require "../private/views/404.view.php";
        }
    }
}
