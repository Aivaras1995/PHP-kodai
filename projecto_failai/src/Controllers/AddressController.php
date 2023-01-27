<?php

namespace Appsas\Controllers;

use Appsas\HtmlRender;
use Appsas\Managers\AddressManager;
use Appsas\Request;
use Appsas\Response;

class AddressController extends BaseController
{
    public const TITLE = 'Adresai';

    public function __construct(protected AddressManager $adr_manager, Response $response, HtmlRender $htmlRender)
    {
        parent::__construct($htmlRender, $response);
    }

    public function list(Request $request): Response
    {
        $address = $this->adr_manager->getAll();
//        $adr_manager = $this->adr_manager->getFiltered($request);
//        $total = $this->adr_manager->getTotal();
        $total = count($address);
        $rez = $this->generateAddressTable($address);

        return $this->render(
            'address/list',
            ['content' => $rez, 'pagination' => $this->generatePagination($total, $request), 'title' => self::TITLE],
            ['title' => self::TITLE]
        );
    }

    public function new(): Response
    {
        return $this->render('address/new');
    }

    public function store(Request $request): Response
    {
        Validator::required($request->get('country_iso'));
        Validator::required($request->get('city'));
        Validator::required($request->get('street'));
        Validator::required((int)$request->get('postcode'));
        Validator::numeric((int)$request->get('postcode'));

        $this->adr_manager->store($request);

        return $this->redirect('/address', ['message' => "Record created successfully"]);
    }

    public function delete(Request $request): Response
    {
        $id = (int)$request->get('id');

        Validator::required($id);
        Validator::numeric($id);
        Validator::min($id, 1);

        $this->adr_manager->delete($request);

        return $this->redirect('/address', ['message' => "Record deleted successfully"]);
    }

    public function edit(Request $request): Response
    {
        $address = $this->adr_manager->getOne($request);

        return $this->render('address/edit', $address);
    }

    public function update(Request $request): Response
    {
        Validator::required($request->get('country_iso'));
        Validator::required($request->get('city'));
        Validator::required($request->get('street'));
        Validator::numeric($request->get('postcode'));

        $this->adr_manager->update($request);

        return $this->redirect('/address/show?id=' . $request->get('id'), ['message' => "Record updated successfully"]);
    }

    public function show(Request $request): Response
    {
        $person = $this->adr_manager->getOne($request);

        return $this->render('person/show', $person);
    }

    /**
     * @param array $adresai
     * @return string
     */
    protected function generateAddressTable(array $adresai): string
    {
        $rez = '<table class="highlight striped">
            <tr>
                <th>ID</th>
                <th>Šalis</th>
                <th>Miestas</th>
                <th>Gatvė</th>
                <th>Pašto kodas</th>
                <th>Veiksmai</th>
            </tr>';
        foreach ($adresai as $adresas) {
            $rez .= $this->htmlRender->renderTemplate('person/person_row', $adresas);
        }
        $rez .= '</table>';
        return $rez;
    }

}