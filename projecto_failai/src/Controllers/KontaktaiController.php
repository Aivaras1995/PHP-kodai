<?php

namespace Projektasx\Controllers;

use Projektasx\FS;
use Projektasx\Response;
use Monolog\Logger;

class KontaktaiController extends BaseController
{
    public function index(): Response
    {
        // Nuskaitomas HTML failas ir siunciam jo teksta i Output klase
        $failoSistema = new FS('../src/html/kontaktai.html');
        $failoTurinys = $failoSistema->getFailoTurinys();

        return $this->response($failoTurinys);
    }
}