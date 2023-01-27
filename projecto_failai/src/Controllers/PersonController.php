<?php

namespace Projektasx\Controllers;

use Projektasx\Database;
use Projektasx\FS;
use Projektasx\HtmlRender;
use Projektasx\Request;
use Projektasx\Response;
use Projektasx\Validator;
use Projektasx\Configs;
use Projektasx\Managers\PersonsManager;

class PersonController extends BaseController
{
    public const TITLE = 'Asmenys';
    public function __construct(protected PersonsManager $manager)
    {
     parent::__construct();
    }

    public function list(): Response
    {
// TODO: Perkelti Filtravima
//
//        $kiekis = $request->get('amount', 10);
//        $orderBy = $request->get('orderby', 'id');
//
//        $searchQuery = '';
//        $params = [];
//        $search = $request->get('search');
//        if ($search) {
//            $searchQuery = "WHERE first_name LIKE :search OR last_name LIKE :search OR code LIKE :search";
//            $params['search'] = '%' . $search . '%';
//        }

        $asmenys = $this->manager->getAll();

        $rez = $this->generatePersonsTable($asmenys);

        return $this->response($rez);
    }

    public function new(): Response
    {
//      Nuskaitomas HTML failas ir siunciam jo teksta i Output klase
        $failoSistema = new FS('../src/html/person/new.html');
        $failoTurinys = $failoSistema->getFailoTurinys();

        return $this->response($failoTurinys);
    }

    public function store(): Response
    {
        $vardas = $_POST['vardas'] ?? '';
        $pavarde = $_POST['pavarde'] ?? '';
        $kodas = (int)$_POST['kodas'] ?? '';

        Validator::required($vardas);
        Validator::required($pavarde);
        Validator::required($kodas);
        Validator::numeric($kodas);
        Validator::asmensKodas($kodas);

        $conf = new Configs();
        $conn = new Database($conf);

        $conn->query(
            "INSERT INTO `persons` (`first_name`, `last_name`, `code`)
                    VALUES (:vardas, :pavarde, :kodas)",
            [
                'vardas' => $vardas,
                'pavarde' => $pavarde,
                'kodas' => $kodas,
            ]
        );

        return $this->redirect('/persons', ['message' => "Record created successfully"]);
    }

    public function delete(): Response
    {
        $kuris = (int)$_GET['id'] ?? null;

        Validator::required($kuris);
        Validator::numeric($kuris);
        Validator::min($kuris, 1);

        return $this->redirect('/persons', ['message' => "Record deleted successfully"]);
    }

    public function edit(Request $request): Response
    {
        $person = $this->manager->getOne((int)$request->get('id'));

        return $this->render('person/edit', $person);
    }

    public function update(Request $request): Response
    {
        Validator::required($request->get('vardas'));
        Validator::required($request->get('pavarde'));
        Validator::required($request->get('kodas'));
        Validator::numeric($request->get('kodas'));
        Validator::asmensKodas($request->get('kodas'));

        $conf = new Configs();
        $db = new Database($conf);

        $db->query(
            "UPDATE `persons` SET `first_name` = :vardas, `last_name` = :pavarde, `code` = :kodas, `email` = :email,
                     `phone` = :tel, `address_id` = :addr_id WHERE `id` = :id",
            $request->all()
        );

        return $this->redirect('/person/show?id='.$request->get('id'), ['message' => "Record updated successfully"]);
    }

    public function show(): Response
    {
        $failoSistema = new FS('../src/html/person/show.html');
        $failoTurinys = $failoSistema->getFailoTurinys();

        $conf = new Configs();
        $db = new Database($conf);

        $person = $db->query("SELECT * FROM `persons` WHERE `id` = :id", ['id' => $_GET['id']])[0];

        foreach ($person as $key => $item) {
            $failoTurinys = str_replace("{{" . $key . "}}", $item, $failoTurinys);
        }

        return $this->response($failoTurinys);
    }

    /**
     * @param mixed $asmuo
     * @return string
     */
    protected function generatePersonRow(array $asmuo): string
    {
        $failoSistema = new FS('../src/html/person/person_row.html');
        $failoTurinys = $failoSistema->getFailoTurinys();
        foreach ($asmuo as $key => $item) {
            $failoTurinys = str_replace("{{" . $key . "}}", $item??'', $failoTurinys);
        }

        return $failoTurinys;
    }

    /**
     * @param array $asmenys
     * @return string
     */
    protected function generatePersonsTable(array $asmenys): string
    {
        $rez = '<table class="highlight striped">
            <tr>
                <th>ID</th>
                <th>Vardas</th>
                <th>Pavarde</th>
                <th>Emailas</th>
                <th>Asmens kodas</th>
                <th><a href="/persons?orderby=phone">TEl</a></th>
                <th>Addr.ID</th>
                <th>Veiksmai</th>
            </tr>';
        foreach ($asmenys as $asmuo) {
            $rez .= $this->generatePersonRow($asmuo);
        }
        $rez .= '</table>';
        return $rez;
    }
}